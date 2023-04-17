﻿
Процедура ОбработкаПроведения(Отказ, Режим)
	
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
	
	Если (НеКонтролироватьОстатки <> Истина) И НЕ НеКонтролироватьОстаткиСвойство И ДополнительныеСвойства.Свойство("РезультатКонтроль") Тогда
		
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
	
	ЭтоПередача = ВидОперации = Перечисления.ВидыОперацийПередачиТоваровВПроизводство.ПередачаПереработчику;
	
	СоответствиеСчета = ДополнительныеСвойства.СоответствиеСчета;
	СоответствиеУчетаПоПодразделениям = ДополнительныеСвойства.СоответствиеУчетаПоПодразделениям;
	
	СчетЗабаланса = ПланыСчетов.Учетный.Счет002();
	СчетЗатратыПроизводство = ПланыСчетов.Учетный.Счет25();//.ОсновноеПрво;
	СчетСебестоимость = Справочники.УчетныеПолитики.СчетКорректировкиСеб(Предприятие);//.Себестоимость;
	
	СтатьяПоУмолчанию = Справочники.СтатьиЗатрат.НайтиПоНаименованию("Списание недостач", Истина);
	СлужбаПоУмолчанию = Справочники.Субконто.НайтиПоНаименованию("Производство_общее");
	
	ПроизводственноеПодразделение = Подразделение.ПроизводственноеПодразделение;
	
	Движения.Учетный.Записывать = Истина;
	
	РезультатОстатки = ДополнительныеСвойства.РезультатОстатки;
	РезультатКонтроль = ДополнительныеСвойства.РезультатКонтроль;
	РезультатКонтрольМинусов = ДополнительныеСвойства.РезультатКонтрольМинусов;
	
	Для Каждого ТекСтрокаТабличнаяЧасть Из ТабличнаяЧасть Цикл
		//Если УЧ_Сервер.НеЗаполненностьКоличестваИЦеныВТЧДок(ТекСтрокаТабличнаяЧасть) = Истина Тогда //проверка на заполненность кол-ва или цены
		//	
		//	Отказ = Истина;
		//	Сообщить("У документа "+ ЭтотОбъект + ", в строке №"+ТекСтрокаТабличнаяЧасть.НомерСтроки+" не заполнено количество и цена.");
		//КонецЕсли;  
		Если сабОбщегоНазначенияПовтИсп.ПолучитьНаличиеСерийногоУчетаДляСчета(ТекСтрокаТабличнаяЧасть.СчетУчета) Тогда 
			НайденныеСерии = СерииНоменклатуры.НайтиСтроки(Новый Структура("Номенклатура, НомерСтрокиРеализации", ТекСтрокаТабличнаяЧасть.Номенклатура, ТекСтрокаТабличнаяЧасть.НомерСтроки));
			МассивСерий = Новый Массив;
			Если НайденныеСерии.Количество() > 1 Тогда //несколько серий
				Для каждого ТекНайдСерия Из НайденныеСерии Цикл
					МассивСерий.Добавить(Новый Структура("СерияНоменклатуры, Количество, Сумма", ТекНайдСерия.СерияНоменклатуры, ТекНайдСерия.Количество, ?(ТекСтрокаТабличнаяЧасть.Количество, ТекСтрокаТабличнаяЧасть.Сумма / ТекСтрокаТабличнаяЧасть.Количество, 0) * ТекНайдСерия.Количество));
				КонецЦикла;	
			Иначе	
				МассивСерий.Добавить(Новый Структура("СерияНоменклатуры, Количество, Сумма", ТекСтрокаТабличнаяЧасть.СерияНоменклатуры, ТекСтрокаТабличнаяЧасть.Количество, ТекСтрокаТабличнаяЧасть.Сумма));
			КонецЕсли;
			ОсталосьРаспределитьСумма = ТекСтрокаТабличнаяЧасть.Сумма;
			ТекИндекс = 0;
			ТекСумма = 0;
			Для каждого ТекСерия Из МассивСерий Цикл
				ТекИндекс = ТекИндекс + 1;
				Движение = Движения.Учетный.Добавить();
				Движение.Период = Дата;
				Движение.СценарийПлана = Справочники.СценарииПланирования.НайтиПоНаименованию("Факт", Истина);
				Движение.Предприятия = Предприятие;
				Движение.СчетКт = ?(ЗначениеЗаполнено(ТекСтрокаТабличнаяЧасть.СчетУчета), ТекСтрокаТабличнаяЧасть.СчетУчета, СоответствиеСчета.Получить(ТекСтрокаТабличнаяЧасть.Номенклатура));
				УчетПоподразделениямСчетУчета = СоответствиеУчетаПоПодразделениям.Получить(Движение.СчетКт);
				УЧ_Сервер.УстановитьСубконто(Движение.СубконтоКт,Движение.СчетКт,1,ТекСтрокаТабличнаяЧасть.Номенклатура);
				УЧ_Сервер.УстановитьСубконто(Движение.СубконтоКт,Движение.СчетКт,2,ТекСтрокаТабличнаяЧасть.Склад);
				УЧ_Сервер.УстановитьСубконто(Движение.СубконтоКт,Движение.СчетКт,3,ТекСерия.СерияНоменклатуры);
				Если УчетПоподразделениямСчетУчета Тогда
					Движение.ПодразделениеКт = Подразделение;
				КонецЕсли;
				ТекКорСчет = ?(ЗначениеЗаполнено(ТекСтрокаТабличнаяЧасть.КорСчет), ТекСтрокаТабличнаяЧасть.КорСчет, Счет);
				Если ЭтоПередача Тогда
					Движение.СчетДт = ТекКорСчет;
					УЧ_Сервер.УстановитьСубконто(Движение.СубконтоДт,ТекКорСчет,1,ТекСтрокаТабличнаяЧасть.Номенклатура);
					УЧ_Сервер.УстановитьСубконто(Движение.СубконтоДт,ТекКорСчет,2,Субконто2);
					УЧ_Сервер.УстановитьСубконто(Движение.СубконтоДт,ТекКорСчет,3,Субконто3);
				Иначе	
					Движение.СчетДт = ТекКорСчет;
					УЧ_Сервер.УстановитьСубконто(Движение.СубконтоДт,ТекКорСчет,1,ТекСтрокаТабличнаяЧасть.КорСубконто1);
					УЧ_Сервер.УстановитьСубконто(Движение.СубконтоДт,ТекКорСчет,2,ТекСтрокаТабличнаяЧасть.КорСубконто2);
					УЧ_Сервер.УстановитьСубконто(Движение.СубконтоДт,ТекКорСчет,3,ТекСтрокаТабличнаяЧасть.КорСубконто3);
				КонецЕсли;
				Если Движение.СчетДт.УчетПоПодразделениям Тогда
					Движение.ПодразделениеДт = ТекСтрокаТабличнаяЧасть.КорПодразделение;
				КонецЕсли;
				Если Движение.СчетДт.Количественный Тогда
					Движение.КоличествоДт = ТекСерия.Количество;
				КонецЕсли;
				Движение.КоличествоКт = ТекСерия.Количество;
				Движение.Сумма = ?(ТекИндекс = МассивСерий.Количество(), ОсталосьРаспределитьСумма, ТекСерия.Сумма);
				Движение.Содержание = Комментарий;
				Если ОтражатьЗаБалансом Тогда //д1 26.09.18
					Движение = Движения.Учетный.Добавить();
					Движение.Период = Дата;
					Движение.СценарийПлана = Справочники.СценарииПланирования.НайтиПоНаименованию("Факт", Истина);
					Движение.Предприятия = Предприятие;
					Движение.СчетДт = СчетЗабаланса;
					УЧ_Сервер.УстановитьСубконто(Движение.СубконтоДт,СчетЗабаланса,1,ТекСтрокаТабличнаяЧасть.Номенклатура);
					УЧ_Сервер.УстановитьСубконто(Движение.СубконтоДт,СчетЗабаланса,2,ТекСтрокаТабличнаяЧасть.Склад);
					//УЧ_Сервер.УстановитьСубконто(Движение.СубконтоДт,ТекСтрокаТабличнаяЧасть.СчетЗатрат,3,ТекСтрокаТабличнаяЧасть.Субконто3);
					Если Движение.СчетДт.УчетПоПодразделениям Тогда
						Движение.ПодразделениеДт = ТекСтрокаТабличнаяЧасть.КорПодразделение;
					КонецЕсли;
					Если Движение.СчетДт.Количественный Тогда
						Движение.КоличествоДт = ТекСерия.Количество;
					КонецЕсли;
					Движение.Сумма = ?(ТекИндекс = МассивСерий.Количество(), ОсталосьРаспределитьСумма, ТекСерия.Сумма);
					Движение.Содержание = "Отражение за балансом";		
				КонецЕсли;
				ОсталосьРаспределитьСумма = ОсталосьРаспределитьСумма - Движение.Сумма;
				ТекСумма = ТекСумма + Движение.Сумма;
			КонецЦикла;
		Иначе
			Движение = Движения.Учетный.Добавить();
			Движение.Период = Дата;
			Движение.СценарийПлана = Справочники.СценарииПланирования.НайтиПоНаименованию("Факт", Истина);
			Движение.Предприятия = Предприятие;
			
			Движение.СчетКт = ?(ЗначениеЗаполнено(ТекСтрокаТабличнаяЧасть.СчетУчета), ТекСтрокаТабличнаяЧасть.СчетУчета, СоответствиеСчета.Получить(ТекСтрокаТабличнаяЧасть.Номенклатура));
			УчетПоподразделениямСчетУчета = СоответствиеУчетаПоПодразделениям.Получить(Движение.СчетКт);
			УЧ_Сервер.УстановитьСубконто(Движение.СубконтоКт,Движение.СчетКт,1,ТекСтрокаТабличнаяЧасть.Номенклатура);
			УЧ_Сервер.УстановитьСубконто(Движение.СубконтоКт,Движение.СчетКт,2,ТекСтрокаТабличнаяЧасть.Склад);
			УЧ_Сервер.УстановитьСубконто(Движение.СубконтоКт,Движение.СчетКт,3,ТекСтрокаТабличнаяЧасть.СерияНоменклатуры);
			
			Если УчетПоподразделениямСчетУчета Тогда
				Движение.ПодразделениеКт = Подразделение;
			КонецЕсли;
			
			ТекКорСчет = ?(ЗначениеЗаполнено(ТекСтрокаТабличнаяЧасть.КорСчет), ТекСтрокаТабличнаяЧасть.КорСчет, Счет);
			Если ЭтоПередача Тогда
				Движение.СчетДт = ТекКорСчет;
				УЧ_Сервер.УстановитьСубконто(Движение.СубконтоДт,ТекКорСчет,1,ТекСтрокаТабличнаяЧасть.Номенклатура);
				УЧ_Сервер.УстановитьСубконто(Движение.СубконтоДт,ТекКорСчет,2,Субконто2);
				УЧ_Сервер.УстановитьСубконто(Движение.СубконтоДт,ТекКорСчет,3,Субконто3);
			Иначе	
				Движение.СчетДт = ТекКорСчет;
				УЧ_Сервер.УстановитьСубконто(Движение.СубконтоДт,ТекКорСчет,1,ТекСтрокаТабличнаяЧасть.КорСубконто1);
				УЧ_Сервер.УстановитьСубконто(Движение.СубконтоДт,ТекКорСчет,2,ТекСтрокаТабличнаяЧасть.КорСубконто2);
				УЧ_Сервер.УстановитьСубконто(Движение.СубконтоДт,ТекКорСчет,3,ТекСтрокаТабличнаяЧасть.КорСубконто3);
			КонецЕсли;
			
			Если Движение.СчетДт.УчетПоПодразделениям Тогда
				Движение.ПодразделениеДт = ТекСтрокаТабличнаяЧасть.КорПодразделение;
			КонецЕсли;
			
			Если Движение.СчетДт.Количественный Тогда
				Движение.КоличествоДт = ТекСтрокаТабличнаяЧасть.Количество;
			КонецЕсли;
			
			Движение.КоличествоКт = ТекСтрокаТабличнаяЧасть.Количество;
			Движение.Сумма = ТекСтрокаТабличнаяЧасть.Сумма;
			Движение.Содержание = Комментарий;
			
			Если ОтражатьЗаБалансом Тогда //д1 26.09.18
				Движение = Движения.Учетный.Добавить();
				Движение.Период = Дата;
				Движение.СценарийПлана = Справочники.СценарииПланирования.НайтиПоНаименованию("Факт", Истина);
				Движение.Предприятия = Предприятие;
				
				Движение.СчетДт = СчетЗабаланса;
				УЧ_Сервер.УстановитьСубконто(Движение.СубконтоДт,СчетЗабаланса,1,ТекСтрокаТабличнаяЧасть.Номенклатура);
				УЧ_Сервер.УстановитьСубконто(Движение.СубконтоДт,СчетЗабаланса,2,ТекСтрокаТабличнаяЧасть.Склад);
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
			ТекСумма = Движение.Сумма;
		КонецЕсли; //Серийный учет
		
		СтруктураПоиска = Новый Структура("Номенклатура, Склад, Счет", ТекСтрокаТабличнаяЧасть.Номенклатура, Склад, Движение.СчетКт);
		ВыборкаДетальныеЗаписи = РезультатОстатки.НайтиСтроки(СтруктураПоиска);
		Если ВыборкаДетальныеЗаписи.Количество() Тогда
			ТекСуммаСтрока = ВыборкаДетальныеЗаписи[0].Цена * ТекСтрокаТабличнаяЧасть.Количество;
			ТекЦена = ВыборкаДетальныеЗаписи[0].Цена;
		Иначе
			ТекСуммаСтрока = 0;
			ТекЦена = 0;
		КонецЕсли;
		
		СчетДт = Движение.СчетДт;
		
		//контроль выхода из минуса
		Если ВидОперации = Перечисления.ВидыОперацийПередачиТоваровВПроизводство.ПередачаПереработчику Тогда
			СтруктураПоискаМинусов = Новый Структура("Номенклатура", ТекСтрокаТабличнаяЧасть.Номенклатура); 
			НайденныеСтрокиМинусов = РезультатКонтрольМинусов.НайтиСтроки(СтруктураПоискаМинусов);
			Для каждого ТекСтрокаМинусов Из НайденныеСтрокиМинусов Цикл
				Если НЕ Окр(ТекСтрокаМинусов.СуммаКонечное + ТекСумма - ТекЦена * ТекСтрокаМинусов.КоличествоКонечное, 2) Тогда
					Продолжить;			
				КонецЕсли;
				Движение = Движения.Учетный.Добавить();
				Движение.Период = Дата;
				Движение.СценарийПлана = Справочники.СценарииПланирования.НайтиПоНаименованию("Факт", Истина);
				Движение.Предприятия = Предприятие;
				
				//вставка на выбор счета (обр №00000000687 Сети)
				Если ПроизводственноеПодразделение Тогда
					Движение.СчетДт = СчетЗатратыПроизводство;
					УЧ_Сервер.УстановитьСубконто(Движение.СубконтоДт,Движение.СчетДт,1,СтатьяПоУмолчанию);
					//Если Движение.СчетДт.ВидыСубконто.Количество() >= 2 Тогда
					//	УЧ_Сервер.УстановитьСубконто(Движение.СубконтоДт,Движение.СчетДт,2,СлужбаПоУмолчанию);
					//КонецЕсли;
				Иначе	
					Движение.СчетДт = СчетСебестоимость;
					УЧ_Сервер.УстановитьСубконто(Движение.СубконтоДт,Движение.СчетДт,1,ТекСтрокаМинусов.Номенклатура);
					//УЧ_Сервер.УстановитьСубконто(Движение.СубконтоДт,Движение.СчетДт,3,СтатьяФормальнаяСебестоимость);
				КонецЕсли;	
				//конец вставки
				
				Если Движение.СчетДт.УчетПоПодразделениям Тогда
					Движение.ПодразделениеДт = Подразделение;
				КонецЕсли;
				Движение.СчетКт = СчетДт;
				Если Движение.СчетКт.УчетПоПодразделениям Тогда
					Движение.ПодразделениеКт = Подразделение;
				КонецЕсли;	
				УЧ_Сервер.УстановитьСубконто(Движение.СубконтоКт,Движение.СчетКт,1,ТекСтрокаМинусов.Номенклатура);
				//Если ЭтоПеремещениеНаОбособленноеПодразделение Тогда
				//	УЧ_Сервер.УстановитьСубконто(Движение.СубконтоКт,Движение.СчетКт,2,Подразделение);
				//Иначе
					УЧ_Сервер.УстановитьСубконто(Движение.СубконтоКт,Движение.СчетКт,2,Субконто2);
				//КонецЕсли;
				Движение.Сумма = ТекСтрокаМинусов.СуммаКонечное + ТекСумма - ТекЦена * ТекСтрокаМинусов.КоличествоКонечное;
				Движение.Содержание = "Корректировка до с/с последнего перемещения " + Формат(ТекЦена, "ЧДЦ=2") ;
			КонецЦикла;
		КонецЕсли; 
		
	КонецЦикла;
	
	
	//оптимизация проведения. проверка на изменения проводок
	//сабОперОбщегоНазначения.ПроверитьПроводкиНаИзменение(Движения.Учетный, ДополнительныеСвойства.КоличественныеПоказателиПроводокДляПроверки);
	
КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)
	
	Для Каждого ТекСтрокаТабличнаяЧасть Из ТабличнаяЧасть Цикл
		ТекСтрокаТабличнаяЧасть.Сумма = 0;
	КонецЦикла;
	РучнаяКорректировка = Ложь;
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	ДокументОснование = "";
	РучнаяКорректировка = Ложь;
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	УстановитьПривилегированныйРежим(Истина);
	
	Если Не ДополнительныеСвойства.Свойство("НеОтрабатыватьТЧ") Тогда
		Для каждого ТекСтрока Из ЭтотОбъект.ТабличнаяЧасть Цикл
			Если ЗначениеЗаполнено(ЭтотОбъект.Подразделение) Тогда
				ТекСтрока.ВидДеятельности = ЭтотОбъект.Подразделение;
			КонецЕсли;
			Если ЗначениеЗаполнено(ЭтотОбъект.КорПодразделение) Тогда
				ТекСтрока.КорПодразделение = ЭтотОбъект.КорПодразделение;
			КонецЕсли;	
			Если ЗначениеЗаполнено(ЭтотОбъект.Склад) Тогда
				ТекСтрока.Склад = ЭтотОбъект.Склад;
			КонецЕсли;	
			Если ЗначениеЗаполнено(ЭтотОбъект.Счет) Тогда
				ТекСтрока.КорСчет = ЭтотОбъект.Счет;
				ТекСтрока.КорСубконто1 = ЭтотОбъект.Субконто1;
				ТекСтрока.КорСубконто2 = ЭтотОбъект.Субконто2;
				ТекСтрока.КорСубконто3 = ЭтотОбъект.Субконто3;
			КонецЕсли;	
		КонецЦикла; 
	КонецЕсли;
	
	СтруктураИмен = УЧ_Сервер.СформироватьСтруктуруИмен(ЭтотОбъект);
	
	СтруктураСоответствий = УЧ_Сервер.ПоучитьСоответствияСчетовНоменклатуры(ЭтотОбъект, СтруктураИмен, ПланыСчетов.Учетный.Счет1001());
	СоответствиеСчета = СтруктураСоответствий.Соответствия;
	СоответствиеУчетаПоПодразделениям = СтруктураСоответствий.СоответствияУчетаПодразделений;
	ДополнительныеСвойства.Вставить("СоответствиеСчета", СоответствиеСчета);
	ДополнительныеСвойства.Вставить("СоответствиеУчетаПоПодразделениям", СоответствиеУчетаПоПодразделениям);
	
	ТаблицаОстатков = УЧ_Сервер.ПолучитьТаблицуОстатков(ЭтотОбъект, СтруктураИмен, СтруктураСоответствий);
	РезультатОстатки = ТаблицаОстатков.РезультатОстатки;
	РезультатКонтроль = ТаблицаОстатков.РезультатКонтроль;
	РезультатКонтрольМинусов = ТаблицаОстатков.РезультатКонтрольМинусов;
	
	Для Каждого ТекСтрокаТабличнаяЧасть Из ТабличнаяЧасть Цикл
		СчетКт = ?(ЗначениеЗаполнено(ТекСтрокаТабличнаяЧасть.СчетУчета), ТекСтрокаТабличнаяЧасть.СчетУчета, СоответствиеСчета.Получить(ТекСтрокаТабличнаяЧасть.Номенклатура));
		УчетПоподразделениямСчетУчета = СоответствиеУчетаПоПодразделениям.Получить(СчетКт);
		
		Если УчетПоподразделениямСчетУчета Тогда
			СтруктураПоиска = Новый Структура("Номенклатура, Склад, Счет, Подразделение", ТекСтрокаТабличнаяЧасть.Номенклатура, ?(ЗначениеЗаполнено(Склад), Склад, ТекСтрокаТабличнаяЧасть.Склад), СоответствиеСчета.Получить(ТекСтрокаТабличнаяЧасть.Номенклатура), Подразделение);
		Иначе	
			СтруктураПоиска = Новый Структура("Номенклатура, Склад, Счет", ТекСтрокаТабличнаяЧасть.Номенклатура, ?(ЗначениеЗаполнено(Склад), Склад, ТекСтрокаТабличнаяЧасть.Склад), СоответствиеСчета.Получить(ТекСтрокаТабличнаяЧасть.Номенклатура));
		КонецЕсли;
		ВыборкаДетальныеЗаписи = РезультатОстатки.НайтиСтроки(СтруктураПоиска);
		Если ТекСтрокаТабличнаяЧасть.Количество <> 0 Тогда
			Если ВыборкаДетальныеЗаписи.Количество() Тогда
				Если ТекСтрокаТабличнаяЧасть.Количество = ВыборкаДетальныеЗаписи[0].Количество Тогда
					ТекСтрокаТабличнаяЧасть.Цена = ВыборкаДетальныеЗаписи[0].Цена;
					ТекСтрокаТабличнаяЧасть.Сумма = ВыборкаДетальныеЗаписи[0].Сумма;
				Иначе	
					ТекСтрокаТабличнаяЧасть.Цена = ВыборкаДетальныеЗаписи[0].Цена;
					ТекСтрокаТабличнаяЧасть.Сумма = ВыборкаДетальныеЗаписи[0].Цена * ТекСтрокаТабличнаяЧасть.Количество;
				КонецЕсли;
			Иначе
				ТекСтрокаТабличнаяЧасть.Цена = 0;
				ТекСтрокаТабличнаяЧасть.Сумма = 0;
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	ДополнительныеСвойства.Вставить("РезультатОстатки", РезультатОстатки);
	ДополнительныеСвойства.Вставить("РезультатКонтроль", РезультатКонтроль);
	ДополнительныеСвойства.Вставить("РезультатКонтрольМинусов", РезультатКонтрольМинусов);
	УстановитьПривилегированныйРежим(Ложь);
	
	СуммаДокумента = ТабличнаяЧасть.Итог("Сумма");
	
	//дата изменена
	Если ЗначениеЗаполнено(Ссылка) И НЕ Дата = Ссылка.Дата Тогда
		ДополнительныеСвойства.Вставить("ДатаДокументаИзменена", Истина);		
	КонецЕсли;
	
	//из подписки на событие
	БюджетныйНаСервере.ДокументыПередЗаписьюПередЗаписью(ЭтотОбъект, Отказ, РежимЗаписи, РежимПроведения);
КонецПроцедуры

Процедура ПриУстановкеНовогоНомера(СтандартнаяОбработка, Префикс)
	БюджетныйНаСервере.ПриУстановкеНовогоНомераПриУстановкеНовогоНомера(ЭтотОбъект, СтандартнаяОбработка, Префикс);
КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)
	Если ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.УЧ_ПоступлениеТоваров") Тогда
		
		Отказ = сабОперОбщегоНазначения.ПроверкаСозданияНаОснованииНаСервере(ДанныеЗаполнения, Комментарий, СтандартнаяОбработка);
		Если Отказ.Признак = "##УжеСоздан" Тогда
			ВызватьИсключение "На основании Поступление ТМЦ и услуг (упр) уже введен документ " + Отказ.Ссылка;
		ИначеЕсли Отказ.Признак = "##НеПроведен" Тогда
			ВызватьИсключение "Документ Поступление ТМЦ и услуг (упр) не проведен. Ввод на основании не возможен.";
		КонецЕсли;
		
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, ДанныеЗаполнения, , "Дата, Номер");
		ДокументОснование = ДанныеЗаполнения;
		Для Каждого СтрокаТовары Из ДанныеЗаполнения.ТабличнаяЧасть Цикл
			СтрокаТЧ = ТабличнаяЧасть.Добавить();
			ЗаполнитьЗначенияСвойств(СтрокаТЧ, СтрокаТовары);
		КонецЦикла;
		
	КонецЕсли;
	
	сабОбщегоНазначенияБУХ.сабОбработкиЗаполненияУчпетныхДокументовОбработкаЗаполнения(ЭтотОбъект, ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка);
КонецПроцедуры

Процедура ОбработкаЗаполненияСФормы(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка) Экспорт
	
	ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка);	
	
КонецПроцедуры
