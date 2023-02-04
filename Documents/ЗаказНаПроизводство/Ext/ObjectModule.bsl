﻿
Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	//из подписки на событие
	БюджетныйНаСервере.ДокументыПередЗаписьюПередЗаписью(ЭтотОбъект, Отказ, РежимЗаписи, РежимПроведения);
КонецПроцедуры

Процедура ПриУстановкеНовогоНомера(СтандартнаяОбработка, Префикс)
	БюджетныйНаСервере.ПриУстановкеНовогоНомераПриУстановкеНовогоНомера(ЭтотОбъект, СтандартнаяОбработка, Префикс);
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	Статус = Перечисления.СтатусыЗаказовНаПроизводство.Новый;
	
	Для каждого строкаТ из ЭтотОбъект.ТабличнаяЧасть Цикл
		
		НовыйГуид = Новый УникальныйИдентификатор; 
		Для каждого строкаВ из ЭтотОбъект.Материалы Цикл
			СтрокаВ.УИДТЧ = НовыйГуид;
		КонецЦикла;
		строкаТ.УИД = НовыйГуид;
		
	КонецЦикла;
	
	ДатаПроизводства = КонецДня(ТекущаяДата()) + 1*24*60*60;

КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.ЗаказКлиента") Тогда
		
		//Отказ = сабОперОбщегоНазначения.ПроверкаСозданияНаОснованииНаСервере(ДанныеЗаполнения, Комментарий, СтандартнаяОбработка, ТипЗнч(Ссылка));
		//Если Отказ.Признак = "##УжеСоздан" Тогда
		//	ВызватьИсключение "На основании Заказ клиента уже введен документ " + Отказ.Ссылка;
		//ИначеЕсли Отказ.Признак = "##НеПроведен" Тогда
		//	ВызватьИсключение "Документ Заказ клиента не проведен. Ввод на основании не возможен.";
		//КонецЕсли;
		
		// Заполнение шапки
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, ДанныеЗаполнения,,"Проведен, Номер, Дата");
		ДокОснование 	= ДанныеЗаполнения.Ссылка;
		УчитыватьНДС 	= Ложь;
		СуммаВключаетНДС = Истина;

		ТабличнаяЧасть.Очистить();
		
		Для Каждого ТекСтрокаТабличнаяЧасть Из ДанныеЗаполнения.ТабличнаяЧасть Цикл
			
			НоваяСтрока = ТабличнаяЧасть.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрока, ТекСтрокаТабличнаяЧасть);
			НоваяСтрока.УИД = Новый УникальныйИдентификатор;
			
			НоваяСтрока.Спецификация = Документы.ЗаказНаПроизводство.ТабличнаяЧастьНоменклатураПриИзмененииНаСервере(НоваяСтрока.Номенклатура);
			УстановитьМатериалыПоСпецификации(НоваяСтрока.Спецификация, НоваяСтрока.Количество, НоваяСтрока.УИД);

		КонецЦикла;
		
	КонецЕсли;	

КонецПроцедуры

&НаСервере
Процедура УстановитьМатериалыПоСпецификации(ТекСпецификация, ПервоначальноеКоличество, ТекУИД)
	
	ТаблицаМатериалов = Материалы.Выгрузить();
	
	ПодчиненныеСтроки = ТаблицаМатериалов.НайтиСтроки(Новый Структура("УИДТЧ", ТекУИД));
	Для Каждого ПодчиненнаяСтрока Из ПодчиненныеСтроки Цикл
		ТаблицаМатериалов.Удалить(ПодчиненнаяСтрока);	
	КонецЦикла;	
	
	ЗапросПоСпецификациям = Новый Запрос;
	ЗапросПоСпецификациям.Текст = 
	"ВЫБРАТЬ
	|	МАКСИМУМ(Спецификации.Дата) КАК Дата,
	|	Спецификации.Владелец КАК Продукция
	|ПОМЕСТИТЬ ВТ_ПоследнииСпецификации
	|ИЗ
	|	Справочник.СпецификацииНоменклатуры КАК Спецификации
	|ГДЕ
	//|	НЕ Спецификации.Ссылка.Вид = ЗНАЧЕНИЕ(Перечисление.ВидыСпецификаций.Разруб)
	|	НЕ Спецификации.Ссылка.ПометкаУдаления
	|	И НЕ Спецификации.Ссылка В (&СписокСпецификаций)
	|	И Спецификации.Дата <= &Дата
	|
	|СГРУППИРОВАТЬ ПО
	|	Спецификации.Владелец
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	СпецификацииСостав.Ссылка КАК Спецификация,
	|	СпецификацииСостав.Ссылка.Владелец КАК Продукция,
	|	СпецификацииСостав.Номенклатура КАК Материал,
	|	СпецификацииСостав.Ссылка.Дата КАК Дата,
	|	СпецификацииСостав.Количество
	//|	СпецификацииСостав.ОтходыПриХолоднойОбработке,
	//|	СпецификацииСостав.МассаНетто,
	//|	СпецификацииСостав.ПотериПриТепловойОбработке,
	//|	СпецификацииСостав.Ссылка.Выход
	|ИЗ
	|	ВТ_ПоследнииСпецификации КАК ВТ_ПоследнииСпецификации
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.СпецификацииНоменклатуры.ИсходныеКомплектующие КАК СпецификацииСостав
	|		ПО ВТ_ПоследнииСпецификации.Дата = СпецификацииСостав.Ссылка.Дата
	|			И ВТ_ПоследнииСпецификации.Продукция = СпецификацииСостав.Ссылка.Владелец
	|ГДЕ
	|	НЕ СпецификацииСостав.Ссылка.ПометкаУдаления
	//|	И НЕ СпецификацииСостав.Ссылка.Вид = ЗНАЧЕНИЕ(Перечисление.ВидыСпецификаций.Разруб)
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	СпецификацииСостав.Ссылка,
	|	СпецификацииСостав.Ссылка.Владелец,
	|	СпецификацииСостав.Номенклатура,
	|	СпецификацииСостав.Ссылка.Дата,
	|	СпецификацииСостав.Количество
	//|	СпецификацииСостав.ОтходыПриХолоднойОбработке,
	//|	СпецификацииСостав.МассаНетто,
	//|	СпецификацииСостав.ПотериПриТепловойОбработке,
	//|	СпецификацииСостав.Ссылка.Выход
	|ИЗ
	|	Справочник.СпецификацииНоменклатуры.ИсходныеКомплектующие КАК СпецификацииСостав
	|ГДЕ
	|	СпецификацииСостав.Ссылка В(&СписокСпецификаций)
	|
	|УПОРЯДОЧИТЬ ПО
	|	Дата УБЫВ";
	ЗапросПоСпецификациям.УстановитьПараметр("СписокСпецификаций", ТекСпецификация);
	ЗапросПоСпецификациям.УстановитьПараметр("Дата", ?(ЗначениеЗаполнено(Дата), Дата, ТекущаяДата())); 
	РезультатЗапроса = ЗапросПоСпецификациям.Выполнить();
	ТаблицаСпецификаций = РезультатЗапроса.Выгрузить();
	
	//Если выпуск по спецификации, то спишем сразу материалы в производство
	Если ЗначениеЗаполнено(ТекСпецификация) Тогда
		НайденныйСоставСпецификаций = ТаблицаСпецификаций.НайтиСтроки(Новый Структура("Спецификация", ТекСпецификация));
		Для Каждого СоставСпецификаций Из НайденныйСоставСпецификаций Цикл
			ТекКоэф = 1;
			//находим подчиненные спецификации
			СоставПодчиненнойСпецификации = ТаблицаСпецификаций.НайтиСтроки(Новый Структура("Продукция", СоставСпецификаций.Материал));
			Если СоставПодчиненнойСпецификации.Количество() > 0 Тогда
				Для Каждого СтрокаПодчиненнойСпецификации Из СоставПодчиненнойСпецификации Цикл
					ТекКоэф1 = ТекКоэф * СтрокаПодчиненнойСпецификации.Количество;
					СоставПодчиненнойСпецификации2 = ТаблицаСпецификаций.НайтиСтроки(Новый Структура("Продукция", СтрокаПодчиненнойСпецификации.Материал));
					Если СоставПодчиненнойСпецификации2.Количество() > 0 Тогда
						Для Каждого СтрокаПодчиненнойСпецификации2 Из СоставПодчиненнойСпецификации2 Цикл
							ТекКоэф2 = ТекКоэф1 * СтрокаПодчиненнойСпецификации2.Количество;
							СоставПодчиненнойСпецификации3 = ТаблицаСпецификаций.НайтиСтроки(Новый Структура("Продукция", СтрокаПодчиненнойСпецификации2.Материал));
							Если СоставПодчиненнойСпецификации3.Количество() > 0 Тогда
								Для Каждого СтрокаПодчиненнойСпецификации3 Из СоставПодчиненнойСпецификации3 Цикл
									ТекКоэф3 = ТекКоэф2 * СтрокаПодчиненнойСпецификации3.Количество;
									СоставПодчиненнойСпецификации4 = ТаблицаСпецификаций.НайтиСтроки(Новый Структура("Продукция", СтрокаПодчиненнойСпецификации3.Материал));
									Если СоставПодчиненнойСпецификации4.Количество() > 0 Тогда
										Для Каждого СтрокаПодчиненнойСпецификации4 Из СоставПодчиненнойСпецификации4 Цикл
											ТекКоэф4 = ТекКоэф3 * СтрокаПодчиненнойСпецификации4.Количество;
											СтрокаТаблМатериалов = ТаблицаМатериалов.Добавить();
											СтрокаТаблМатериалов.Коэффициент = ТекКоэф4;
											СтрокаТаблМатериалов.Количество = СтрокаПодчиненнойСпецификации4.Количество * ТекКоэф4;
											СтрокаТаблМатериалов.Материал = СтрокаПодчиненнойСпецификации4.Материал;
											СтрокаТаблМатериалов.УИДТЧ = ТекУИД;
										КонецЦикла;	
									Иначе
										СтрокаТаблМатериалов = ТаблицаМатериалов.Добавить();
										СтрокаТаблМатериалов.Коэффициент = ТекКоэф3;
										СтрокаТаблМатериалов.Количество = СтрокаПодчиненнойСпецификации3.Количество * ТекКоэф3;
										СтрокаТаблМатериалов.Материал = СтрокаПодчиненнойСпецификации3.Материал;
										СтрокаТаблМатериалов.УИДТЧ = ТекУИД;
									КонецЕсли;
								КонецЦикла;	
							Иначе
								СтрокаТаблМатериалов = ТаблицаМатериалов.Добавить();
								СтрокаТаблМатериалов.Коэффициент = ТекКоэф2;
								СтрокаТаблМатериалов.Количество = СтрокаПодчиненнойСпецификации2.Количество * ТекКоэф2;
								СтрокаТаблМатериалов.Материал = СтрокаПодчиненнойСпецификации2.Материал;
								СтрокаТаблМатериалов.УИДТЧ = ТекУИД;
							КонецЕсли;
						КонецЦикла;
					Иначе
						СтрокаТаблМатериалов = ТаблицаМатериалов.Добавить();	
						СтрокаТаблМатериалов.Коэффициент = ТекКоэф1;
						СтрокаТаблМатериалов.Количество = СтрокаПодчиненнойСпецификации.Количество * ТекКоэф1;
						СтрокаТаблМатериалов.Материал = СтрокаПодчиненнойСпецификации.Материал;
						СтрокаТаблМатериалов.УИДТЧ = ТекУИД;
					КонецЕсли;
				КонецЦикла;
			Иначе
				СтрокаТаблМатериалов = ТаблицаМатериалов.Добавить();
				СтрокаТаблМатериалов.Коэффициент = ТекКоэф;
				СтрокаТаблМатериалов.Количество = СоставСпецификаций.Количество * ТекКоэф;
				СтрокаТаблМатериалов.Материал = СоставСпецификаций.Материал;
				СтрокаТаблМатериалов.УИДТЧ = ТекУИД;
			КонецЕсли;
		КонецЦикла;	
	КонецЕсли;	
	//
	
	Материалы.Загрузить(ТаблицаМатериалов);
	
КонецПроцедуры	

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	УЧ_ВыпускПродукции.Ссылка КАК Ссылка
	               |ИЗ
	               |	Документ.УЧ_ВыпускПродукции КАК УЧ_ВыпускПродукции
	               |ГДЕ
	               |	УЧ_ВыпускПродукции.ДокОснование = &ДокОснование
	               |	И УЧ_ВыпускПродукции.Проведен = ИСТИНА";
	
	Запрос.УстановитьПараметр("ДокОснование", Ссылка);
	
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	
	ЕстьПоступление = Ложь;
	Пока Выборка.Следующий() Цикл
		ЕстьПоступление = Истина;
	КонецЦикла;

	// регистр Учетный 
	Движения.Учетный.Записывать = Истина;
	
	Если ЕстьПоступление Тогда //оичщаем проводки
		Возврат;
	КонецЕсли;
	
	СчетРезервов = ПланыСчетов.Учетный.СчетЗАК();
	УчетПоПодразделениям = СчетРезервов.УчетПоПодразделениям;
	СценарийПлана = Справочники.СценарииПланирования.СценарийФакт();
	
	Если Не ЗначениеЗаполнено(СчетРезервов) Тогда
		Возврат;	
	КонецЕсли;
	
	Если НЕ Статус = Перечисления.СтатусыЗаказовНаПроизводство.Отменен И НЕ Статус = Перечисления.СтатусыЗаказовНаПроизводство.Произведен Тогда
		Для Каждого ТекСтрокаТабличнаяЧасть Из ТабличнаяЧасть Цикл
			
			Движение = Движения.Учетный.Добавить();
			Движение.СчетДт = СчетРезервов;
			Движение.Период = ДатаПроизводства;
			Движение.Предприятия = Предприятие;
			Если УчетПоПодразделениям Тогда
				Движение.ПодразделениеДт = Подразделение;
			КонецЕсли;
			Движение.СценарийПлана = СценарийПлана;
			//Движение.Сумма = ТекСтрокаТабличнаяЧасть.Сумма;
			Движение.КоличествоДт = ТекСтрокаТабличнаяЧасть.Количество;
			Движение.Содержание = Комментарий;
			УЧ_Сервер.УстановитьСубконто(Движение.СубконтоДт, Движение.СчетДт, 1, ТекСтрокаТабличнаяЧасть.Номенклатура);
			УЧ_Сервер.УстановитьСубконто(Движение.СубконтоДт, Движение.СчетДт, 2, ТекСтрокаТабличнаяЧасть.Склад);
			
			МатериалыОтобранные = Материалы.НайтиСтроки(Новый Структура("УИДТЧ", ТекСтрокаТабличнаяЧасть.УИД));
			
			Для Каждого ТекСтрокаМатериалы Из МатериалыОтобранные Цикл
				
				Движение = Движения.Учетный.Добавить();
				Движение.СчетКт = СчетРезервов;
				Движение.Период = Дата;
				Движение.Предприятия = Предприятие;
				Если УчетПоПодразделениям Тогда
					Движение.ПодразделениеКт = Подразделение;
				КонецЕсли;
				Движение.СценарийПлана = СценарийПлана;
				//Движение.Сумма = ТекСтрокаТабличнаяЧасть.Сумма;
				Движение.КоличествоКт = ТекСтрокаМатериалы.Количество;
				Движение.Содержание = Комментарий;
				УЧ_Сервер.УстановитьСубконто(Движение.СубконтоКт, Движение.СчетКт, 1, ТекСтрокаМатериалы.Материал);
				УЧ_Сервер.УстановитьСубконто(Движение.СубконтоКт, Движение.СчетКт, 2, Склад);
				
			КонецЦикла;
			
		КонецЦикла;
	КонецЕсли;

КонецПроцедуры


