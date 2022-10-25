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
	
	ПеренесеноИзАстор = (УчетПартий.Количество() > 0);
	
	РольУчетчикДоступна = рольдоступна("сабУчетчик");
	СоответствиеСчета = ДополнительныеСвойства.СоответствиеСчета;
	СоответствиеУчетаПоПодразделениям = ДополнительныеСвойства.СоответствиеУчетаПоПодразделениям;
	
	СчетПроизводство = ПланыСчетов.Учетный.НайтиПоКоду("20");//.ОсновноеПрво;
	СчетНедостач = ПланыСчетов.Учетный.НайтиПоКоду("94");//.Недостачи;
	СчетСебестоимость = ПланыСчетов.Учетный.НайтиПоКоду("90.02");//.Недостачи;
	СоответствияСчетаСписания = Новый Соответствие;
	СоответствияСчетаСписания.Вставить(ПланыСчетов.Учетный.Счет41(), СчетСебестоимость);
	СоответствияСчетаСписания.Вставить(ПланыСчетов.Учетный.Счет43(), СчетСебестоимость);
	СоответствияСчетаСписания.Вставить(ПланыСчетов.Учетный.ПустаяСсылка(), СчетСебестоимость);
	СоответствияСчетаСписания.Вставить(ПланыСчетов.Учетный.Счет1001(), СчетПроизводство);
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
		//Если УЧ_Сервер.НеЗаполненностьКоличестваИЦеныВТЧДок(ТекСтрокаТабличнаяЧасть) = Истина Тогда //проверка на заполненность кол-ва или цены
		//	
		//	Отказ = Истина;
		//	Сообщить("У документа "+ ЭтотОбъект + ", в строке №"+ТекСтрокаТабличнаяЧасть.НомерСтроки+" не заполнено количество и цена.");
		//КонецЕсли;    			
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
					УЧ_Сервер.УстановитьСубконто(Движение.СубконтоДт,Движение.СчетДт,1,ТекСтрокаТабличнаяЧасть.Товар);
					УЧ_Сервер.УстановитьСубконто(Движение.СубконтоДт,Движение.СчетДт,3,СоответствияСтатей.Получить(ВидОперации));
				КонецЕсли;	
			КонецЕсли;
			
			Если Движение.СчетДт.УчетПоПодразделениям Тогда
				//Если Движение.СчетДт = СчетПроизводство Тогда
				//	Движение.ПодразделениеДт = ПодразделениеПоУмолчанию;	
				//Иначе	
				Движение.ПодразделениеДт = Подразделение;
				//КонецЕсли;
			КонецЕсли;
			
		КонецЕсли;
		
		УЧ_Сервер.УстановитьСубконто(Движение.СубконтоКт,Движение.СчетКт,1,ТекСтрокаТабличнаяЧасть.Товар);
		УЧ_Сервер.УстановитьСубконто(Движение.СубконтоКт,Движение.СчетКт,2,Склад);
		
		Если Движение.СчетДт.Количественный Тогда
			Движение.КоличествоДт = ТекСтрокаТабличнаяЧасть.Количество;
		КонецЕсли;
		Движение.КоличествоКт = ТекСтрокаТабличнаяЧасть.Количество;		
		
		Если ПеренесеноИзАстор Тогда
			НайденныеСтроки = УчетПартий.НайтиСтроки(Новый Структура("Номенклатура", ТекСтрокаТабличнаяЧасть.Товар));
			ПолученнаяСумма = 0;
			КоличествоПоУчетуПартий = 0;
			Для Каждого НайденнаяСтрока Из НайденныеСтроки Цикл
				ПолученнаяСумма = ПолученнаяСумма + НайденнаяСтрока.СуммаНДС + НайденнаяСтрока.СуммаБезНДС;
				КоличествоПоУчетуПартий = КоличествоПоУчетуПартий + НайденнаяСтрока.Количество;
			КонецЦикла;
			Движение.Сумма = ?(КоличествоПоУчетуПартий = 0, 0, (ПолученнаяСумма * ТекСтрокаТабличнаяЧасть.Количество)/ КоличествоПоУчетуПартий);
		Иначе	
			Движение.Сумма = ТекСтрокаТабличнаяЧасть.Сумма;
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
		
	КонецЦикла;
	
	//оптимизация проведения. проверка на изменения проводок
	//сабОперОбщегоНазначения.ПроверитьПроводкиНаИзменение(Движения.Учетный, ДополнительныеСвойства.КоличественныеПоказателиПроводокДляПроверки);
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	//ДополнительныеСвойства.Вставить("КоличественныеПоказателиПроводокДляПроверки", сабОперОбщегоНазначения.ПолучитьКоличественныеПоказателиПроводок(Ссылка));
	
	ПеренесеноИзАстор = (УчетПартий.Количество() > 0);
	
	Если Не ПеренесеноИзАстор Тогда
		УстановитьПривилегированныйРежим(Истина);
		
		СтруктураИмен = УЧ_Сервер.СформироватьСтруктуруИмен(ЭтотОбъект);
		
		СтруктураСоответствий = УЧ_Сервер.ПоучитьСоответствияСчетовНоменклатуры(ЭтотОбъект, СтруктураИмен);
		СоответствиеСчета = СтруктураСоответствий.Соответствия;
		СоответствиеУчетаПоПодразделениям = СтруктураСоответствий.СоответствияУчетаПодразделений;
		ДополнительныеСвойства.Вставить("СоответствиеСчета", СоответствиеСчета);
		ДополнительныеСвойства.Вставить("СоответствиеУчетаПоПодразделениям", СоответствиеУчетаПоПодразделениям);
		
		ТаблицаОстатков = УЧ_Сервер.ПолучитьТаблицуОстатков(ЭтотОбъект, СтруктураИмен, СтруктураСоответствий);
		РезультатОстатки = ТаблицаОстатков.РезультатОстатки;
		РезультатКонтроль = ТаблицаОстатков.РезультатКонтроль;
		
		Для Каждого ТекСтрокаТабличнаяЧасть Из ТабличнаяЧасть Цикл
			СчетКт = ?(ЗначениеЗаполнено(ТекСтрокаТабличнаяЧасть.СчетУчета), ТекСтрокаТабличнаяЧасть.СчетУчета, СоответствиеСчета.Получить(ТекСтрокаТабличнаяЧасть.Товар));
			УчетПоподразделениямСчетУчета = СоответствиеУчетаПоПодразделениям.Получить(СчетКт);
			
			Если УчетПоподразделениямСчетУчета Тогда
				СтруктураПоиска = Новый Структура("Номенклатура, Склад, Счет, Подразделение", ТекСтрокаТабличнаяЧасть.Товар, Склад, СоответствиеСчета.Получить(ТекСтрокаТабличнаяЧасть.Товар), Подразделение);
			Иначе	
				СтруктураПоиска = Новый Структура("Номенклатура, Склад, Счет", ТекСтрокаТабличнаяЧасть.Товар, Склад, СоответствиеСчета.Получить(ТекСтрокаТабличнаяЧасть.Товар));
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
		ДополнительныеСвойства.Вставить("РезультатКонтроль", РезультатКонтроль);
		УстановитьПривилегированныйРежим(Ложь);
	КонецЕсли;
	
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
		Склад = сабОперОбщегоНазначения.ПолучитьСкладПоДопСвойству(ПланыВидовХарактеристик.ДополнительныеРеквизитыИСведения.НайтиПоНаименованию("Склад инвентаризаций (Склады)", Истина), ДанныеЗаполнения.Подразделение.Владелец);
		Подразделение = ДанныеЗаполнения.Подразделение;
		Организация = ?(ЗначениеЗаполнено(ДанныеЗаполнения.Организация), ДанныеЗаполнения.Организация, Подразделение.Организация);
		ВидОперации = Перечисления.ВидыОперацийСписания.СписаниеПодснятий;
		//Сож+
		Дата = ДанныеЗаполнения.Дата;
		//Сож-
		Для Каждого СтрокаТЧ Из ДанныеЗаполнения.Товары Цикл
			
			Если СтрокаТЧ.Номенклатура.АлкогольнаяПродукция Тогда //д1 кроме алко, алко в отдельной команде
				Продолжить;			
			КонецЕсли;
			
			Если СтрокаТЧ.КоличествоОтклонение < 0 Или (СтрокаТЧ.КоличествоОтклонение = 0 И СтрокаТЧ.СуммаОтклонение < 0)Тогда
				СтрокаТЧСписания = ТабличнаяЧасть.Добавить();
				СтрокаТЧСписания.Товар = СтрокаТЧ.Номенклатура;
				СтрокаТЧСписания.Количество = - СтрокаТЧ.КоличествоОтклонение;
				СтрокаТЧСписания.Сумма = - СтрокаТЧ.СуммаОтклонение;
				СтрокаТЧСписания.Цена = ?(СтрокаТЧ.КоличествоОтклонение = 0, 0, СтрокаТЧ.СуммаОтклонение/СтрокаТЧ.КоличествоОтклонение);
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
		|	(ВТ_ТЧДока.Номенклатура.ТипНоменклатуры = ЗНАЧЕНИЕ(Перечисление.ТипыНоменклатуры.Сырье)
		|			ИЛИ ВТ_ТЧДока.Номенклатура.ТипНоменклатуры = ЗНАЧЕНИЕ(Перечисление.ТипыНоменклатуры.Материалы))";
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
