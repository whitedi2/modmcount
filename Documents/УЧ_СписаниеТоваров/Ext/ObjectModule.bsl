﻿Процедура ОбработкаПроведения(Отказ, Режим)
	
	Если РучнаяКорректировка Тогда		
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru = 'Движения документа %1 отредактированы вручную и не могут быть автоматически актуализированы'"), ЭтотОбъект);
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст = ТекстСообщения;
		Сообщение.КлючДанных = Ссылка;
		Сообщение.Сообщить();		
		
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	// Контроль отритцательных остатков
	//УЧ_Сервер.ПроверитьОтрицательныеОстатки(Ссылка,СоответствиеСчета,Отказ);
	НеКонтролироватьОстаткиСвойство = ?(ДополнительныеСвойства.Свойство("НеКонтролироватьОтрицательныеОстатки"), ДополнительныеСвойства.НеКонтролироватьОтрицательныеОстатки, Ложь);
	НеКонтролироватьОстатки = сабОбщегоНазначения.ПолучитьЗначениеСвойства(ПараметрыСеанса.ТекущийПользователь, "Разрешено проведение без контроля остатков");
	
	//Контроль остатков с учетом бронирования{
	Если (НеКонтролироватьОстатки <> Истина) И НЕ НеКонтролироватьОстаткиСвойство И НЕ РольДоступна("допОтключитьКонтрольОстатков") Тогда
		НастройкаБронированиеТоваров = Справочники.сабМониторВнедрения.ПолучитьЗначениеНастройкиКонстанты("сабБронированиеТоваровВЗаказах");	
		Если НастройкаБронированиеТоваров Тогда
			МассивСообщенийКонтроля = Новый Массив;
			СтруктураИмен = УЧ_Сервер.СформироватьСтруктуруИмен(ЭтотОбъект);
			СтруктураСоответствий = УЧ_Сервер.ПоучитьСоответствияСчетовНоменклатуры(ЭтотОбъект, СтруктураИмен);
			УЧ_Сервер.КонтрольОстатковСУчетомБронирования(ЭтотОбъект, СтруктураИмен, СтруктураСоответствий,МассивСообщенийКонтроля);
			Если МассивСообщенийКонтроля.Количество() > 0 Тогда
				Для каждого СообщениеКонтроля Из МассивСообщенийКонтроля Цикл
					Сообщить(СообщениеКонтроля);
				КонецЦикла;
				Отказ = Истина;
				Возврат;
			КонецЕсли; 
		КонецЕсли;
	КонецЕсли;
	//}Контроль остатков с учетом бронирования

	//Если (НеКонтролироватьОстатки <> Истина) И НЕ НеКонтролироватьОстаткиСвойство И ДополнительныеСвойства.Свойство("РезультатКонтроль") И НЕ Пользователи.РолиДоступны("допОтключитьКонтрольОстатков",,Ложь) Тогда
	Если (НеКонтролироватьОстатки <> Истина) И НЕ НеКонтролироватьОстаткиСвойство И ДополнительныеСвойства.Свойство("РезультатКонтроль") И НЕ РольДоступна("допОтключитьКонтрольОстатков") Тогда
	
		Для каждого ТекСтрокаМинус Из ДополнительныеСвойства.РезультатКонтроль Цикл
			Отказ = Истина;
			Сообщить(?(ТекСтрокаМинус.УчетПоПодразделениям, "По Подразделению " + Строка(ТекСтрокаМинус.Подразделение) + " ", "") + "На Складе """ + Строка(ТекСтрокаМинус.Склад) + """ номенклатуры """ + Строка(ТекСтрокаМинус.Номенклатура) + " (" + Строка(ТекСтрокаМинус.Номенклатура.Код)  + ")"" из необходимых " + Строка(ТекСтрокаМинус.КоличествоНужно) + " присутствует только "  + Строка(ТекСтрокаМинус.КоличествоОстаток) );
		КонецЦикла;   
		
		Если Отказ Тогда
			ДополнительныеСвойства.Вставить("НехваткаОстатков", Истина);		
		КонецЕсли; 
		
	КонецЕсли;//конец контроля остатков 
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	Если ДополнительныеСвойства.Свойство("ДатаДокументаИзменена") Тогда
		Движения.Учетный.Записать();	
	КонецЕсли;
	
	ПеренесеноИзАстор = (УчетПартий.Количество() > 0);
	
	РольУчетчикДоступна = рольдоступна("сабУчетчик");
	СоответствиеСчета = ДополнительныеСвойства.СоответствиеСчета;
	СоответствиеУчетаПоПодразделениям = ДополнительныеСвойства.СоответствиеУчетаПоПодразделениям;
	
	СчетПроизводство = ПланыСчетов.Учетный.НайтиПоКоду("20");//.ОсновноеПрво;
	СчетНедостач = ПланыСчетов.Учетный.НайтиПоКоду("94");//.Недостачи;
	СчетСебестоимость = ПланыСчетов.Учетный.НайтиПоКоду("90.02");//.Недостачи;
	СоответствияСчетаСписания = Новый Соответствие;
	СоответствияСчетаСписания.Вставить(ПланыСчетов.Учетный.Счет41(), СчетНедостач);
	СоответствияСчетаСписания.Вставить(ПланыСчетов.Учетный.Счет43(), СчетНедостач);
	СоответствияСчетаСписания.Вставить(ПланыСчетов.Учетный.ПустаяСсылка(), СчетНедостач);
	СоответствияСчетаСписания.Вставить(ПланыСчетов.Учетный.Счет1001(), СчетНедостач);
	ПодразделениеПоУмолчанию = Справочники.СтруктураПредприятия.НайтиПоНаименованию("Производство_Основное", Истина); //можно вынести в реквизит предприятия, но нудно ли?
	СтатьяПоУмолчанию = Справочники.СтатьиЗатрат.НайтиПоНаименованию("Списание материалов и ГП (недостачи/излишки)", Истина);
	СоответствияСтатей = Новый Соответствие;
	СоответствияСтатей.Вставить(Перечисления.ВидыОперацийСписания.Брак, Справочники.СтатьиЗатрат.НайтиПоНаименованию("Списание брака", Истина));
	СоответствияСтатей.Вставить(Перечисления.ВидыОперацийСписания.ПустаяСсылка(), Справочники.СтатьиЗатрат.НайтиПоНаименованию("Списание брака", Истина));
	СоответствияСтатей.Вставить(Перечисления.ВидыОперацийСписания.Дегустация, Справочники.СтатьиЗатрат.НайтиПоНаименованию("Дегустация", Истина));
	СоответствияСтатей.Вставить(Перечисления.ВидыОперацийСписания.Бракераж, Справочники.СтатьиЗатрат.НайтиПоНаименованию("Бракераж", Истина));
	СлужбаПоУмолчанию = Справочники.Субконто.НайтиПоНаименованию("Производство_общее");
	ЭтоСписаниеВНедостачи = ВидОперации = Перечисления.ВидыОперацийСписания.СписаниеПодснятий;
	СчетЗабаланса = ПланыСчетов.Учетный.Счет002();
	
	Движения.Учетный.Записывать = Истина;
	Для Каждого ТекСтрокаТабличнаяЧасть Из ТабличнаяЧасть Цикл
		
		ТекМол = ?(ЗначениеЗаполнено(МОЛ), МОЛ, ТекСтрокаТабличнаяЧасть.МОЛ);
		
		СчетДляПроверкиСерии = ?(ЗначениеЗаполнено(ТекСтрокаТабличнаяЧасть.СчетУчета), ТекСтрокаТабличнаяЧасть.СчетУчета, СоответствиеСчета.Получить(ТекСтрокаТабличнаяЧасть.Товар));
		
		//Если сабОбщегоНазначенияПовтИсп.ПолучитьНаличиеСерийногоУчетаДляСчета(СчетДляПроверкиСерии) Тогда
		НайденныеСерии = СерииНоменклатуры.НайтиСтроки(Новый Структура("Номенклатура, НомерСтрокиРеализации", ТекСтрокаТабличнаяЧасть.Товар, ТекСтрокаТабличнаяЧасть.НомерСтроки));
		МассивСерий = Новый Массив;
		Если НайденныеСерии.Количество() > 1 Тогда //несколько серий
			Для каждого ТекНайдСерия Из НайденныеСерии Цикл
				МассивСерий.Добавить(Новый Структура("СерияНоменклатуры, Количество, Сумма", ТекНайдСерия.СерияНоменклатуры, ТекНайдСерия.Количество, ТекНайдСерия.Сумма));
			КонецЦикла;	
		Иначе	
			МассивСерий.Добавить(Новый Структура("СерияНоменклатуры, Количество, Сумма", ТекСтрокаТабличнаяЧасть.СерияНоменклатуры, ТекСтрокаТабличнаяЧасть.Количество, ТекСтрокаТабличнаяЧасть.Сумма));
		КонецЕсли;
		ОсталосьРаспределитьСумма = ТекСтрокаТабличнаяЧасть.Сумма;
		ТекИндекс = 0;
		//	Для каждого ТекСерия Из МассивСерий Цикл
		//		ТекИндекс = ТекИндекс + 1;
		//		Движение = Движения.Учетный.Добавить();
		//		Движение.Период = Дата;
		//		Движение.СценарийПлана = Справочники.СценарииПланирования.НайтиПоНаименованию("Факт", Истина);
		//		Движение.Предприятия = Предприятие;
		//		Движение.СчетКт = ?(ЗначениеЗаполнено(ТекСтрокаТабличнаяЧасть.СчетУчета), ТекСтрокаТабличнаяЧасть.СчетУчета, СоответствиеСчета.Получить(ТекСтрокаТабличнаяЧасть.Товар));
		//		УчетПоподразделениямСчетУчета = СоответствиеУчетаПоПодразделениям.Получить(Движение.СчетКт);
		//		Если УчетПоподразделениямСчетУчета Тогда
		//			Движение.ПодразделениеКт = Подразделение;
		//		КонецЕсли;
		//		Если ЗначениеЗаполнено(ТекСтрокаТабличнаяЧасть.СчетЗатрат) Тогда
		//			Движение.СчетДт = ТекСтрокаТабличнаяЧасть.СчетЗатрат;
		//			УЧ_Сервер.УстановитьСубконто(Движение.СубконтоДт,ТекСтрокаТабличнаяЧасть.СчетЗатрат,1,ТекСтрокаТабличнаяЧасть.Субконто1);
		//			УЧ_Сервер.УстановитьСубконто(Движение.СубконтоДт,ТекСтрокаТабличнаяЧасть.СчетЗатрат,2,ТекСтрокаТабличнаяЧасть.Субконто2);
		//			УЧ_Сервер.УстановитьСубконто(Движение.СубконтоДт,ТекСтрокаТабличнаяЧасть.СчетЗатрат,3,ТекСтрокаТабличнаяЧасть.Субконто3);
		//			Если Движение.СчетДт.УчетПоПодразделениям Тогда
		//				Движение.ПодразделениеДт = ТекСтрокаТабличнаяЧасть.КорПодразделение;	
		//			КонецЕсли;
		//		Иначе
		//			Если ЭтоСписаниеВНедостачи Тогда
		//				Движение.СчетДт = СчетНедостач;
		//				УЧ_Сервер.УстановитьСубконто(Движение.СубконтоДт,Движение.СчетДт,1,ТекСтрокаТабличнаяЧасть.Товар);
		//			Иначе	
		//				Если Подразделение.ПроизводственноеПодразделение Тогда
		//					Движение.СчетДт = СчетПроизводство;
		//					УЧ_Сервер.УстановитьСубконто(Движение.СубконтоДт,Движение.СчетДт,1,СтатьяПоУмолчанию);
		//					Если Движение.СчетДт.ВидыСубконто.Количество() >= 2 Тогда
		//						УЧ_Сервер.УстановитьСубконто(Движение.СубконтоДт,Движение.СчетДт,2,СлужбаПоУмолчанию);
		//					КонецЕсли;	
		//				Иначе	
		//					Движение.СчетДт = СоответствияСчетаСписания.Получить(Движение.СчетКт);
		//					Если Не ЗначениеЗаполнено(Движение.СчетДт) Тогда
		//						Движение.СчетДт = СчетСебестоимость; 
		//					КонецЕсли;
		//					УЧ_Сервер.УстановитьСубконто(Движение.СубконтоДт,Движение.СчетДт,1,ТекСтрокаТабличнаяЧасть.Товар);
		//					УЧ_Сервер.УстановитьСубконто(Движение.СубконтоДт,Движение.СчетДт,3,СоответствияСтатей.Получить(ВидОперации));
		//				КонецЕсли;	
		//			КонецЕсли;
		//			Если Движение.СчетДт.УчетПоПодразделениям Тогда
		//				Движение.ПодразделениеДт = ?(ЗначениеЗаполнено(ТекСтрокаТабличнаяЧасть.КорПодразделение), ТекСтрокаТабличнаяЧасть.КорПодразделение, КорПодразделение);
		//			КонецЕсли;
		//		КонецЕсли;
		//		УЧ_Сервер.УстановитьСубконто(Движение.СубконтоКт,Движение.СчетКт,1,ТекСтрокаТабличнаяЧасть.Товар);
		//		УЧ_Сервер.УстановитьСубконто(Движение.СубконтоКт,Движение.СчетКт,2,Склад);
		//		Если НЕ Движение.СчетКт.ВидыСубконто.Найти(ПланыВидовХарактеристик.ВидыСубконто.НайтиПоНаименованию("МОЛ", Истина)) = Неопределено Тогда
		//			УЧ_Сервер.УстановитьСубконто(Движение.СубконтоКт, Движение.СчетКт, 3, ТекМол);
		//		Иначе
		//			УЧ_Сервер.УстановитьСубконто(Движение.СубконтоКт, Движение.СчетКт, 3, ТекСерия.СерияНоменклатуры);
		//		КонецЕсли;
		//		Если Движение.СчетДт.Количественный Тогда
		//			Движение.КоличествоДт = ТекСерия.Количество;
		//		КонецЕсли;
		//		Движение.КоличествоКт = ТекСерия.Количество;		
		//		Если ПеренесеноИзАстор Тогда
		//			НайденныеСтроки = УчетПартий.НайтиСтроки(Новый Структура("Номенклатура", ТекСтрокаТабличнаяЧасть.Товар));
		//			ПолученнаяСумма = 0;
		//			КоличествоПоУчетуПартий = 0;
		//			Для Каждого НайденнаяСтрока Из НайденныеСтроки Цикл
		//				ПолученнаяСумма = ПолученнаяСумма + НайденнаяСтрока.СуммаНДС + НайденнаяСтрока.СуммаБезНДС;
		//				КоличествоПоУчетуПартий = КоличествоПоУчетуПартий + НайденнаяСтрока.Количество;
		//			КонецЦикла;
		//			Движение.Сумма = ?(КоличествоПоУчетуПартий = 0, 0, (ПолученнаяСумма * ТекСерия.Количество)/ КоличествоПоУчетуПартий);
		//		Иначе	
		//			Движение.Сумма = ?(ТекИндекс = МассивСерий.Количество(), ОсталосьРаспределитьСумма, ТекСерия.Сумма);
		//		КонецЕсли;
		//		Движение.Содержание = Комментарий;
		//		Если ОтражатьЗаБалансом Тогда //д1 26.09.18
		//			Движение = Движения.Учетный.Добавить();
		//			Движение.Период = Дата;
		//			Движение.СценарийПлана = Справочники.СценарииПланирования.НайтиПоНаименованию("Факт", Истина);
		//			Движение.Предприятия = Предприятие;
		//			Движение.СчетДт = СчетЗабаланса;
		//			УЧ_Сервер.УстановитьСубконто(Движение.СубконтоДт,СчетЗабаланса,1,ТекСтрокаТабличнаяЧасть.Товар);
		//			УЧ_Сервер.УстановитьСубконто(Движение.СубконтоДт,СчетЗабаланса,2,Склад);
		//			//УЧ_Сервер.УстановитьСубконто(Движение.СубконтоДт,ТекСтрокаТабличнаяЧасть.СчетЗатрат,3,ТекСтрокаТабличнаяЧасть.Субконто3);
		//			Если Движение.СчетДт.УчетПоПодразделениям Тогда
		//				Движение.ПодразделениеДт = ТекСтрокаТабличнаяЧасть.КорПодразделение;
		//			КонецЕсли;
		//			Если Движение.СчетДт.Количественный Тогда
		//				Движение.КоличествоДт = ТекСерия.Количество;
		//			КонецЕсли;
		//			Движение.Сумма = ?(ТекИндекс = МассивСерий.Количество(), ОсталосьРаспределитьСумма, ТекСерия.Сумма);
		//			Движение.Содержание = "Отражение за балансом";		
		//		КонецЕсли;
		//		ОсталосьРаспределитьСумма = ОсталосьРаспределитьСумма - Движение.Сумма;
		//	КонецЦикла;
		//Иначе
		ОсталосьРаспределитьСумма = ТекСтрокаТабличнаяЧасть.Сумма;
		ТекИндекс = 0;
		Для каждого ТекСерия Из МассивСерий Цикл
			ТекИндекс = ТекИндекс + 1;
			Движение = Движения.Учетный.Добавить();
			Движение.Период = Дата;
			Движение.СценарийПлана = Справочники.СценарииПланирования.НайтиПоНаименованию("Факт", Истина);
			Движение.Предприятия = Предприятие;
			Движение.СчетКт = ?(ЗначениеЗаполнено(ТекСтрокаТабличнаяЧасть.СчетУчета), ТекСтрокаТабличнаяЧасть.СчетУчета, СоответствиеСчета.Получить(ТекСтрокаТабличнаяЧасть.Товар));
			УчетПоподразделениямСчетУчета = СоответствиеУчетаПоПодразделениям.Получить(Движение.СчетКт);
			Если УчетПоподразделениямСчетУчета Тогда
				Движение.ПодразделениеКт = Подразделение;
			КонецЕсли;
			Если ЗначениеЗаполнено(ТекСтрокаТабличнаяЧасть.СчетЗатрат) Тогда
				Движение.СчетДт = ТекСтрокаТабличнаяЧасть.СчетЗатрат;
				УЧ_Сервер.УстановитьСубконто(Движение.СубконтоДт,ТекСтрокаТабличнаяЧасть.СчетЗатрат,1,ТекСтрокаТабличнаяЧасть.Субконто1);
				УЧ_Сервер.УстановитьСубконто(Движение.СубконтоДт,ТекСтрокаТабличнаяЧасть.СчетЗатрат,2,ТекСтрокаТабличнаяЧасть.Субконто2);
				УЧ_Сервер.УстановитьСубконто(Движение.СубконтоДт,ТекСтрокаТабличнаяЧасть.СчетЗатрат,3,ТекСтрокаТабличнаяЧасть.Субконто3);
				Если Движение.СчетДт.УчетПоПодразделениям Тогда
					Движение.ПодразделениеДт = ТекСтрокаТабличнаяЧасть.КорПодразделение;	
				КонецЕсли;
			Иначе
				Если ЭтоСписаниеВНедостачи Тогда
					Движение.СчетДт = СчетНедостач;
					УЧ_Сервер.УстановитьСубконто(Движение.СубконтоДт,Движение.СчетДт,1,ТекСтрокаТабличнаяЧасть.Товар);
				Иначе	
					Если Подразделение.ПроизводственноеПодразделение Тогда
						Движение.СчетДт = СчетПроизводство;
						УЧ_Сервер.УстановитьСубконто(Движение.СубконтоДт,Движение.СчетДт,1,СтатьяПоУмолчанию);
						Если Движение.СчетДт.ВидыСубконто.Количество() >= 2 Тогда
							УЧ_Сервер.УстановитьСубконто(Движение.СубконтоДт,Движение.СчетДт,2,СлужбаПоУмолчанию);
						КонецЕсли;	
					Иначе	
						Движение.СчетДт = СоответствияСчетаСписания.Получить(Движение.СчетКт);
						Если Не ЗначениеЗаполнено(Движение.СчетДт) Тогда
							Движение.СчетДт = СчетСебестоимость; 
						КонецЕсли;
						УЧ_Сервер.УстановитьСубконто(Движение.СубконтоДт,Движение.СчетДт,1,ТекСтрокаТабличнаяЧасть.Товар);
						УЧ_Сервер.УстановитьСубконто(Движение.СубконтоДт,Движение.СчетДт,3,СоответствияСтатей.Получить(ВидОперации));
					КонецЕсли;	
				КонецЕсли;
				Если Движение.СчетДт.УчетПоПодразделениям Тогда
					Движение.ПодразделениеДт = ?(ЗначениеЗаполнено(ТекСтрокаТабличнаяЧасть.КорПодразделение), ТекСтрокаТабличнаяЧасть.КорПодразделение, КорПодразделение);
				КонецЕсли;
			КонецЕсли;
			УЧ_Сервер.УстановитьСубконто(Движение.СубконтоКт,Движение.СчетКт,1,ТекСтрокаТабличнаяЧасть.Товар);
			УЧ_Сервер.УстановитьСубконто(Движение.СубконтоКт,Движение.СчетКт,2,Склад);
			Если НЕ Движение.СчетКт.ВидыСубконто.Найти(ПланыВидовХарактеристик.ВидыСубконто.НайтиПоНаименованию("МОЛ", Истина)) = Неопределено Тогда
				УЧ_Сервер.УстановитьСубконто(Движение.СубконтоКт, Движение.СчетКт, 3, ТекМол);
			Иначе
				УЧ_Сервер.УстановитьСубконто(Движение.СубконтоКт, Движение.СчетКт, 3, ТекСерия.СерияНоменклатуры);
			КонецЕсли;
			Если Движение.СчетДт.Количественный Тогда
				Движение.КоличествоДт = ТекСерия.Количество;
			КонецЕсли;
			Движение.КоличествоКт = ТекСерия.Количество;		
			Если ПеренесеноИзАстор Тогда
				НайденныеСтроки = УчетПартий.НайтиСтроки(Новый Структура("Номенклатура", ТекСтрокаТабличнаяЧасть.Товар));
				ПолученнаяСумма = 0;
				КоличествоПоУчетуПартий = 0;
				Для Каждого НайденнаяСтрока Из НайденныеСтроки Цикл
					ПолученнаяСумма = ПолученнаяСумма + НайденнаяСтрока.СуммаНДС + НайденнаяСтрока.СуммаБезНДС;
					КоличествоПоУчетуПартий = КоличествоПоУчетуПартий + НайденнаяСтрока.Количество;
				КонецЦикла;
				//Движение.Сумма = ?(КоличествоПоУчетуПартий = 0, 0, (ПолученнаяСумма * ТекСтрокаТабличнаяЧасть.Количество)/ КоличествоПоУчетуПартий);
				Движение.Сумма = ?(КоличествоПоУчетуПартий = 0, 0, (ПолученнаяСумма * ТекСерия.Количество)/ КоличествоПоУчетуПартий);
			Иначе	
				//Движение.Сумма = ТекСтрокаТабличнаяЧасть.Сумма;
				Движение.Сумма = ?(ТекИндекс = МассивСерий.Количество(), ОсталосьРаспределитьСумма, ТекСерия.Сумма);
			КонецЕсли;
			
			Движение.Содержание = Комментарий;
			
			Если ОтражатьЗаБалансом Тогда //д1 26.09.18
				Движение = Движения.Учетный.Добавить();
				Движение.Период = Дата;
				Движение.СценарийПлана = Справочники.СценарииПланирования.НайтиПоНаименованию("Факт", Истина);
				Движение.Предприятия = Предприятие;
				
				Движение.СчетДт = СчетЗабаланса;
				УЧ_Сервер.УстановитьСубконто(Движение.СубконтоДт,СчетЗабаланса,1,ТекСтрокаТабличнаяЧасть.Товар);
				УЧ_Сервер.УстановитьСубконто(Движение.СубконтоДт,СчетЗабаланса,2,Склад);
				//УЧ_Сервер.УстановитьСубконто(Движение.СубконтоДт,ТекСтрокаТабличнаяЧасть.СчетЗатрат,3,ТекСтрокаТабличнаяЧасть.Субконто3);
				
				Если Движение.СчетДт.УчетПоПодразделениям Тогда
					Движение.ПодразделениеДт = ТекСтрокаТабличнаяЧасть.КорПодразделение;
				КонецЕсли;
				Если Движение.СчетДт.Количественный Тогда
					Движение.КоличествоДт = ТекСтрокаТабличнаяЧасть.Количество;
				КонецЕсли;
				
				Движение.Сумма = ТекСтрокаТабличнаяЧасть.Сумма;
				Движение.Содержание = "Отражение за балансом";		
			КонецЕсли;
			ОсталосьРаспределитьСумма = ОсталосьРаспределитьСумма - Движение.Сумма;
		КонецЦикла;
		//КонецЕсли;	
	КонецЦикла;
	
	//оптимизация проведения. проверка на изменения проводок
	//сабОперОбщегоНазначения.ПроверитьПроводкиНаИзменение(Движения.Учетный, ДополнительныеСвойства.КоличественныеПоказателиПроводокДляПроверки);
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	//ДополнительныеСвойства.Вставить("КоличественныеПоказателиПроводокДляПроверки", сабОперОбщегоНазначения.ПолучитьКоличественныеПоказателиПроводок(Ссылка));
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	
	СтруктураИмен = УЧ_Сервер.СформироватьСтруктуруИмен(ЭтотОбъект);
	
	СтруктураСоответствий = УЧ_Сервер.ПоучитьСоответствияСчетовНоменклатуры(ЭтотОбъект, СтруктураИмен);
	СоответствиеСчета = СтруктураСоответствий.Соответствия;
	СоответствиеУчетаПоПодразделениям = СтруктураСоответствий.СоответствияУчетаПодразделений;
	ДополнительныеСвойства.Вставить("СоответствиеУчетаПоПодразделениям", СоответствиеУчетаПоПодразделениям);
	
	ИспользоватьСерии = Справочники.СерииНоменклатуры.СерииНоменклатурыИспользуются();
	КорректироватьСебестоимостьПриВыходеОстаткаИзМинуса = Справочники.сабМониторВнедрения.ПолучитьЗначениеНастройки("КорректироватьСебестоимостьПриВыходеОстаткаИзМинуса");
	РассчитыватьСебестоимостьПоСериям = Справочники.сабМониторВнедрения.ПолучитьЗначениеНастройки("РассчитыватьСебестоимостьПоСериям");
	
	ДополнительныеСвойства.Вставить("ИспользоватьСерии", ИспользоватьСерии);
	ДополнительныеСвойства.Вставить("КорректироватьСебестоимостьПриВыходеОстаткаИзМинуса", КорректироватьСебестоимостьПриВыходеОстаткаИзМинуса);
	ДополнительныеСвойства.Вставить("РассчитыватьСебестоимостьПоСериям", РассчитыватьСебестоимостьПоСериям);
	
	ТаблицаОстатков = УЧ_Сервер.ПолучитьТаблицуОстатков(ЭтотОбъект, СтруктураИмен, СтруктураСоответствий);
	РезультатОстатки = ТаблицаОстатков.РезультатОстатки;
	РезультатКонтроль = ТаблицаОстатков.РезультатКонтроль;
	
	Для Каждого ТекСтрокаТабличнаяЧасть Из ТабличнаяЧасть Цикл
		
		СчетКт = ?(ЗначениеЗаполнено(ТекСтрокаТабличнаяЧасть.СчетУчета), ТекСтрокаТабличнаяЧасть.СчетУчета, СоответствиеСчета.Получить(ТекСтрокаТабличнаяЧасть.Товар));
		УчетПоподразделениямСчетУчета = СоответствиеУчетаПоПодразделениям.Получить(СчетКт);
		
		СтруктураПоиска = Новый Структура("Номенклатура, Склад", ТекСтрокаТабличнаяЧасть.Товар, Склад);
		
		Если ЗначениеЗаполнено(ТекСтрокаТабличнаяЧасть.СчетУчета) Тогда
			СтруктураПоиска.Вставить("Счет", ТекСтрокаТабличнаяЧасть.СчетУчета); 
		КонецЕсли;
		
		СтрокиСерий = Новый Массив;
		СтрокиСерий.Добавить(ТекСтрокаТабличнаяЧасть);
		
		Если ИспользоватьСерии Тогда
			СтрокиСерий = СерииНоменклатуры.НайтиСтроки(Новый Структура("Номенклатура, НомерСтрокиРеализации", ТекСтрокаТабличнаяЧасть.Товар, ТекСтрокаТабличнаяЧасть.НомерСтроки)); 
			Если СтрокиСерий.Количество() <= 1 Тогда
				СтрокиСерий = Новый Массив;
				СтрокиСерий.Добавить(ТекСтрокаТабличнаяЧасть);
			КонецЕсли;
		КонецЕсли;
		
		Для каждого ТекСерия Из СтрокиСерий Цикл
			
			Если РассчитыватьСебестоимостьПоСериям Тогда
				СтруктураПоиска.Вставить("СерияНоменклатуры", ТекСерия.СерияНоменклатуры);
			КонецЕсли;
			
			ВыборкаДетальныеЗаписи = РезультатОстатки.НайтиСтроки(СтруктураПоиска);
			
			Если РассчитыватьСебестоимостьПоСериям И Не ЗначениеЗаполнено(ТекСерия.СерияНоменклатуры) И НЕ ВыборкаДетальныеЗаписи.Количество() Тогда //если счет без учета по сериям и серия не указана в документе
				СтруктураПоиска.Вставить("СерияНоменклатуры", Неопределено);
				ВыборкаДетальныеЗаписи = РезультатОстатки.НайтиСтроки(СтруктураПоиска);
			КонецЕсли;
			
			Если ТекСерия.Количество <> 0 Тогда
				
				ТекСерия.Цена = 0;
				ТекСерия.Сумма = 0;
				КоличествоОстаток = 0;
				СуммаОстаток = 0;
				Для каждого ТекСтрока Из ВыборкаДетальныеЗаписи Цикл
					КоличествоОстаток = КоличествоОстаток +  ТекСтрока.Количество;	
					СуммаОстаток = СуммаОстаток +  ТекСтрока.Сумма;
					Если НЕ ЗначениеЗаполнено(ТекСтрокаТабличнаяЧасть.СчетУчета) Тогда
						СоответствиеСчета.Вставить(ТекСтрокаТабличнаяЧасть.Товар, ТекСтрока.Счет);
					КонецЕсли;
				КонецЦикла;
				ЦенаОстаток = ?(КоличествоОстаток, СуммаОстаток / КоличествоОстаток, 0);  
				
				Если ТекСерия.Количество = КоличествоОстаток Тогда
					ТекСерия.Цена = ЦенаОстаток;
					ТекСерия.Сумма = СуммаОстаток;
				Иначе	
					ТекСерия.Цена = ЦенаОстаток;
					ТекСерия.Сумма = ЦенаОстаток * ТекСерия.Количество;
				КонецЕсли;
			КонецЕсли;
		КонецЦикла;
		
		//усреднение суммы по номенклатуре в случае нескольких серий
		Если СтрокиСерий.Количество() > 1 Тогда
			ТекСтрокаТабличнаяЧасть.Сумма = 0;
			Для каждого ТекСерия Из СтрокиСерий Цикл
				ТекСтрокаТабличнаяЧасть.Сумма = ТекСтрокаТабличнаяЧасть.Сумма + ТекСерия.Сумма; 
			КонецЦикла;
			ТекСтрокаТабличнаяЧасть.Цена = ?(ТекСтрокаТабличнаяЧасть.Количество, ТекСтрокаТабличнаяЧасть.Сумма / ТекСтрокаТабличнаяЧасть.Количество, 0); 
		КонецЕсли;
		
	КонецЦикла;
	
	ДополнительныеСвойства.Вставить("СоответствиеСчета", СоответствиеСчета);
	ДополнительныеСвойства.Вставить("РезультатКонтроль", РезультатКонтроль);
	УстановитьПривилегированныйРежим(Ложь);
	
	СуммаДокумента = ТабличнаяЧасть.Итог("Сумма");
	
	//дата изменена
	Если ЗначениеЗаполнено(Ссылка) И НЕ Дата = Ссылка.Дата Тогда
		ДополнительныеСвойства.Вставить("ДатаДокументаИзменена", Истина);		
	КонецЕсли;
	
	//из подписки на событие
	БюджетныйНаСервере.ДокументыПередЗаписьюПередЗаписью(ЭтотОбъект, Отказ, РежимЗаписи, РежимПроведения);
	
КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.УЧ_ПеремещениеТоваров") Тогда
		Отказ = сабОперОбщегоНазначения.ПроверкаСозданияНаОснованииНаСервере(ДанныеЗаполнения, Комментарий, СтандартнаяОбработка);
		Если Отказ.Признак = "##УжеСоздан" Тогда
			ВызватьИсключение "На основании Перемещение ТМЦ (упр) уже введен документ " + Отказ.Ссылка;
		ИначеЕсли Отказ.Признак = "##НеПроведен" Тогда
			ВызватьИсключение "Документ Перемещение ТМЦ (упр) не проведен. Ввод на основании не возможен.";
		КонецЕсли;
		
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, ДанныеЗаполнения, ,"Дата, Номер, Комментарий, ДокОснование");
		ДокОснование = ДанныеЗаполнения.Ссылка;
		Склад = ДанныеЗаполнения.СкладПолучатель;
		Подразделение = ДанныеЗаполнения.ПодразделениеПолучатель;
		Организация = ДанныеЗаполнения.ОрганизацияПолучатель;
		Для Каждого СтрокаТЧ Из ДанныеЗаполнения.ТабличнаяЧасть Цикл
			СтрокаТЧСписания = ТабличнаяЧасть.Добавить();
			ЗаполнитьЗначенияСвойств(СтрокаТЧСписания, СтрокаТЧ);
			СтрокаТЧСписания.Товар = СтрокаТЧ.Номенклатура;
		КонецЦикла;
	ИначеЕсли ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.УЧ_Инвентаризация") Тогда
		//Отказ = сабОперОбщегоНазначения.ПроверкаСозданияНаОснованииНаСервере(ДанныеЗаполнения, Комментарий, СтандартнаяОбработка);
		//Если НЕ Отказ = Неопределено Тогда
		//	Возврат;		
		//КонецЕсли;
		
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, ДанныеЗаполнения, ,"Дата, Номер, Комментарий");
		ДокОснование = ДанныеЗаполнения.Ссылка;
		ВидОперации = Перечисления.ВидыОперацийСписания.СписаниеПодснятий;
		Дата = ДанныеЗаполнения.Дата;
		
		Для Каждого СтрокаТЧ Из ДанныеЗаполнения.Товары Цикл
			
			//Если СтрокаТЧ.Номенклатура.АлкогольнаяПродукция Тогда //д1 кроме алко, алко в отдельной команде
			//	Продолжить;			
			//КонецЕсли;
			
			Если СтрокаТЧ.КоличествоОтклонение < 0 Или (СтрокаТЧ.КоличествоОтклонение = 0 И СтрокаТЧ.СуммаОтклонение < 0)Тогда
				СтрокаТЧСписания = ТабличнаяЧасть.Добавить();
				СтрокаТЧСписания.Товар = СтрокаТЧ.Номенклатура;
				СтрокаТЧСписания.Количество = - СтрокаТЧ.КоличествоОтклонение;
				СтрокаТЧСписания.Сумма = - СтрокаТЧ.СуммаОтклонение;
				СтрокаТЧСписания.Цена = ?(СтрокаТЧ.КоличествоОтклонение = 0, 0, СтрокаТЧ.СуммаОтклонение/СтрокаТЧ.КоличествоОтклонение);
				СтрокаТЧСписания.СерияНоменклатуры = СтрокаТЧ.СерияНоменклатуры; 
				СтрокаТЧСписания.СчетУчета = СтрокаТЧ.СчетУчета;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	сабОбщегоНазначенияБУХ.сабОбработкиЗаполненияУчпетныхДокументовОбработкаЗаполнения(ЭтотОбъект, ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка);
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	Склад = Справочники.Склады.ПустаяСсылка();
	РучнаяКорректировка = Ложь;
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Если (Не Подразделение.ПроизводственноеПодразделение) И (Не ВидОперации = Перечисления.ВидыОперацийСписания.СписаниеПодснятий) И Ложь Тогда
		ТЧДока = Новый ТаблицаЗначений;
		ТЧДока.Колонки.Добавить("Номенклатура", Новый ОписаниеТипов("СправочникСсылка.Номенклатура"));
		ТЧДока.Колонки.Добавить("НомерСтроки", Новый ОписаниеТипов("Число", , , Новый КвалификаторыЧисла(15,3)));
		
		Для Каждого СтрокаТЧ Из ТабличнаяЧасть Цикл
			СтрокаТЧДока = ТЧДока.Добавить();
			СтрокаТЧДока.Номенклатура = СтрокаТЧ.Товар;
			СтрокаТЧДока.НомерСтроки = СтрокаТЧ.НомерСтроки;
		КонецЦикла;	
		
		Запрос = Новый Запрос;
		Запрос.Текст = 
		"ВЫБРАТЬ
		|	ТЧДокумента.НомерСтроки,
		|	ТЧДокумента.Номенклатура
		|ПОМЕСТИТЬ ВТ_ТЧДока
		|ИЗ
		|	&ТЧДокумента КАК ТЧДокумента
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ВТ_ТЧДока.НомерСтроки,
		|	ВТ_ТЧДока.Номенклатура,
		|	ВТ_ТЧДока.Номенклатура.ТипНоменклатуры КАК ТипНоменклатуры
		|ИЗ
		|	ВТ_ТЧДока КАК ВТ_ТЧДока
		|ГДЕ
		|	(ВТ_ТЧДока.Номенклатура.ТипНоменклатуры = ЗНАЧЕНИЕ(Перечисление.сабТипыНоменклатуры.Сырье)
		|			ИЛИ ВТ_ТЧДока.Номенклатура.ТипНоменклатуры = ЗНАЧЕНИЕ(Перечисление.сабТипыНоменклатуры.Материалы))";
		Запрос.УстановитьПараметр("ТЧДокумента", ТЧДока);
		
		РезультатЗапроса = Запрос.Выполнить();
		
		Если Не РезультатЗапроса.Пустой() Тогда
			Отказ = Истина;
			Выборка = РезультатЗапроса.Выбрать();
			Пока Выборка.Следующий() Цикл
				Сообщение = Новый СообщениеПользователю();
				Сообщение.Поле = "ТабличнаяЧасть[" + Строка(Выборка.НомерСтроки - 1) + "].Товар";
				Сообщение.Текст = "В строке " + Выборка.НомерСтроки + " выбрана номенклатура с неправильным типом: " + Выборка.ТипНоменклатуры;
				Сообщение.УстановитьДанные(ЭтотОбъект);
				Сообщение.Сообщить();
			КонецЦикла;
		КонецЕсли; 
	КонецЕсли;
	
	//Если ВидОперации = Перечисления.ВидыОперацийСписания.СписаниеПодснятий Тогда
	//	РеквизитКоличество = ПроверяемыеРеквизиты.Найти("ТабличнаяЧасть.Количество");
	//	ПроверяемыеРеквизиты.Удалить(РеквизитКоличество);
	//КонецЕсли;
	
	//д1. для больших чисел (возможно вынести в общий модуль)
	Для каждого ТекСтрока Из ТабличнаяЧасть Цикл
		Если ТекСтрока.Количество > 1000000 Тогда
			сабОбщегоНазначенияКлиентСервер.СообщитьОбОшибке(ЭтотОбъект, "Слишком большое количество, введите еще раз.", "ТабличнаяЧасть", ТекСтрока.НомерСтроки, "Количество", Ложь);
			Отказ = Истина;
		КонецЕсли;
	КонецЦикла; 
	
КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)
	РучнаяКорректировка = Ложь;
КонецПроцедуры

Процедура ПриУстановкеНовогоНомера(СтандартнаяОбработка, Префикс)
	БюджетныйНаСервере.ПриУстановкеНовогоНомераПриУстановкеНовогоНомера(ЭтотОбъект, СтандартнаяОбработка, Префикс);
КонецПроцедуры

Процедура ОбработкаЗаполненияСФормы(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка) Экспорт
	
	ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка);	
	
КонецПроцедуры
